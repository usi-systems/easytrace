header_type ethernet_t {
    fields {
        dl_dst : 48;
        dl_src : 48;
        dl_type : 16;
    }
}

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
header easytrace_head_t easytrace_head;
/* TODO: initialize the easytrace_port header(s) */
header easytrace_metadata_t ingress_meta;

parser start {
    return parse_ethernet;
}

#define EASYTRACE_PROTOCOL 0x6900
parser parse_ethernet {
    extract(eth);
    return select(latest.dl_type) {
        EASYTRACE_PROTOCOL : parse_head;
    	default : ingress;
    }
}


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
    modify_field(eth.dl_type, EASYTRACE_PROTOCOL);
}

/* TODO: define the easytrace table (HINT: match on the ethernet type) */

action forward(port) {
    modify_field(standard_metadata.egress_spec, port);
}

table forward_tbl {
    reads {
        eth.dl_dst : exact;
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
