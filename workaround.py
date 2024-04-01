from scapy.all import *
from threading import Thread
import time

# This will store the translation details
translation_details = {}

def monitor_icmp_errors(iface):
    def handle_icmp_error(packet):
        if packet.haslayer(ICMP) and packet.haslayer(IPerror) and packet.haslayer(UDPerror):
            # Extract the original source IP and source port from the ICMP payload
            original_src_ip = packet[IPerror].src
            original_src_port = packet[UDPerror].sport
            icmp_id = packet[ICMP].id  # Or some other unique identifier
            translation_details[icmp_id] = (original_src_ip, original_src_port)

    sniff(iface=iface, prn=handle_icmp_error, filter="icmp", store=0)

def modify_and_forward_packet(iface):
    def forward_packet(packet):
        # This assumes the ICMP error has a unique identifier we can match on
        icmp_id = packet[ICMP].id  # Or some other unique identifier
        if icmp_id in translation_details:
            # Add the translated src and sport into the ICMP payload
            nat_src, nat_sport = translation_details[icmp_id]
            payload = f"Translated Src IP: {nat_src}, Src Port: {nat_sport}"
            packet[Raw].load = payload.encode()

            # Correct the checksums
            del packet[ICMP].chksum
            del packet[IP].chksum
            packet = packet.__class__(bytes(packet))  # Recalculate checksums

            # Forward the packet to the internal node
            sendp(packet, iface=iface, verbose=0)

    sniff(iface=iface, prn=forward_packet, filter="icmp", store=0)

# Start the thread to monitor ICMP errors coming from the external interface
Thread(target=monitor_icmp_errors, args=("eth1",)).start()

# Give some time for the sniffer to start
time.sleep(1)

# Start the thread to modify and forward packets going to the internal interface
Thread(target=modify_and_forward_packet, args=("eth0",)).start()
