#!/usr/bin/env python

from scapy.all import *
import sys
import argparse

class EasyRoute(Packet):
    name = "EasyRoute "
    fields_desc = [ XIntField("num_port", 0x0)]

class EasyPort(Packet):
    name = "EasyPort "
    fields_desc = [ XByteField("port", 0x1)]


bind_layers(UDP, EasyRoute, dport=0x6900)

arp_table = {"10.0.0.1": "00:00:00:00:00:01", "10.0.0.2": "00:00:00:00:00:02", "10.0.0.3": "00:00:00:00:00:03"}

def client(args):
    p = Ether(dst=arp_table[args.destination]) / IP (dst=args.destination) / UDP(sport=12345, dport=args.port)
    p.show()
    sendp(p, iface = args.interface)

def handle(x):
    x.show()

def server(itf):
    sniff(iface = itf, prn = lambda x: handle(x))

def main():
    parser = argparse.ArgumentParser(description='receiver and sender to test P4 program')
    parser.add_argument("-s", "--server", help="run as server", action="store_true")
    parser.add_argument("-c", "--client", help="run as client", action="store_true")
    parser.add_argument("-t", "--trace", help="run trace route", default=True, action="store_true")
    parser.add_argument("-i", "--interface", default='eth0', help="bind to specified interface")
    parser.add_argument("-p", "--port", type=int, default=0x6901, help="UDP destination Port")
    parser.add_argument("-d", "--destination", help="IP address of the destination")
    args = parser.parse_args()

    if args.server:
        server(args.interface)
    elif args.client:
        if args.destination == None:
            print "Missing destination IP address"
            parser.print_help()
        else:
            client(args)
    else:
        parser.print_help()

if __name__=='__main__':
    main()