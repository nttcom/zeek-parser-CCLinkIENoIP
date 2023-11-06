# @TEST-DOC: Test Zeek parsing a trace file through the cc_link_noip analyzer.
#
# @TEST-EXEC: zeek -Cr ${TRACES}/udp-port-12345.pcap ${PACKAGE} %INPUT >output
# @TEST-EXEC: btest-diff output
# @TEST-EXEC: btest-diff cc_link_noip.log

# TODO: Adapt as suitable. The example only checks the output of the event
# handlers.

event cc_link_noip::message(c: connection, is_orig: bool, payload: string)
    {
    print fmt("Testing cc_link_noip: [%s] %s %s", (is_orig ? "request" : "reply"), c$id, payload);
    }
