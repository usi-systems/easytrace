header_type ethernet_t {
    fields {
        dl_dst : 48;
        dl_src : 48;
        dl_type : 16;
    }
}

header_type ipv4_t {
    fields {
        version : 4;
        ihl : 4;
        diffserv : 8;
        totalLen : 16;
        identification : 16;
        flags : 3;
        fragOffset : 13;
        ttl : 8;
        protocol : 8;
        hdrChecksum : 16;
        srcAddr : 32;
        dstAddr : 32;
    }
}
/* TODO: define UDP header */


header_type easytrace_head_t {
    fields {
        num_valid : 32;
    }
}

/* TODO: define the easytrace_port header */


// the metadata needed in parsing variable number of ports
header_type easytrace_metadata_t {
    fields {
        num_port : 32;
    }
}


header ethernet_t eth;
header ipv4_t ipv4;

/* TODO: initialize the UDP header instance */


header easytrace_head_t easytrace_head;

/* TODO: initialize the easytrace_port header(s) */

header easytrace_metadata_t ingress_meta;

parser start {
    return parse_ethernet;
}

parser parse_ethernet {
    extract(eth);
    return select(latest.dl_type) {
        0x800 : parse_ipv4;
        default: ingress;
    }
}

#define EASYTRACE_PROTOCOL 0xFD
parser parse_ipv4 {
    extract(ipv4);
    /* TODO: parse UDP or EASYTRACE */
    return ingress;
}

/* TODO: parse UDP header */

parser parse_head {
    /* TODO: extract header and parse ports if needed */
    return ingress;
}

/* TODO: add parser for the easytrace_port */


action _drop() {
    drop();
}

action _nop() {

}

action add_port() {
    /* TODO: increase number of ports */
    /* TODO: add easytrace_port to the header stack (HINT: push header) */
    /* TODO: modify the easytrace_port by the output port */
}

action add_easytrace_head() {
    /* TODO: add easytrace_head */
    add_port();
    /* Modify the IP protocol to EASYTRACE */
}

/* TODO: define the easytrace table (HINT: match on the ethernet type) */

action forward(port) {
    modify_field(standard_metadata.egress_spec, port);
}

table forward_tbl {
    reads {
        ipv4.dstAddr : exact;
    } actions {
        forward;
        _drop;
    }
}

control ingress {
    apply(forward_tbl);
    /* TODO: apply the table to add easytrace head and ports  */
}

control egress {
    // leave empty
}
