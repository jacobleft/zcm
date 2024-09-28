
using ZCM

module zcmtypes
include("zcmtypes/_msg_t.jl")
end

using .zcmtypes

msg_buffer::Vector{String} = String[]
function callback_handler(rbuf::ZCM.RecvBuf, channel::String, msgdata)
    ccall(:jl_, Nothing, (Any,), "Received message on channel $(channel)")
    msg = decode(msg_t, msgdata)
    push!(msg_buffer,msg.str)
    ccall(:jl_, Nothing, (Any,), "msg.str = '$(msg.str)'")
end

zcmipc = ZCM.Zcm("ipc")

ZCM.subscribe(zcmipc, "HELLO_WORLD", callback_handler) 

ZCM.start(zcmipc)

ZCM.stop(zcmipc)


#include <stdio.h>
#include <zcm/zcm.h>
#include <msg_t.h>
# void callback_handler(const zcm_recv_buf_t *rbuf, const char *channel, const msg_t *msg, void *usr)
# {
#     printf("Received a message on channel '%s'\n", channel);
#     printf("msg->str = '%s'\n", msg->str);
#     printf("\n");
# }

# int main(int argc, char *argv[])
# {
#     zcm_t *zcm = zcm_create("ipc");
#     msg_t_subscribe(zcm, "HELLO_WORLD", callback_handler, NULL);

#     zcm_run(zcm);

#     // Can also call zcm_start(zcm); to spawn a new thread that calls zcm_run(zcm);
#     //
#     // zcm_start(zcm)
#     // while(!done) { do stuff; sleep; }
#     // zcm_stop(zcm);
#     //

#     zcm_destroy(zcm);
#     return 0;
# }