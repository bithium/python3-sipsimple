# cython: language_level=3

from ._pjsip cimport (
    pj_list,
    pj_mutex_t,
    pj_str_t,
    pjmedia_sdp_session_ptr_const,
    pjsip_dialog,
    pjsip_event,
    pjsip_evsub,
    pjsip_hdr,
    pjsip_inv_callback,
    pjsip_inv_session,
    pjsip_msg_body,
    pjsip_role_e,
    pjsip_route_hdr,
    pjsip_rx_data,
    pjsip_transaction,
)
from .headers cimport (
    BaseContactHeader,
    FrozenContactHeader,
    FrozenFromHeader,
    FrozenRouteHeader,
    FrozenToHeader,
)
from .helper cimport FrozenCredentials, FrozenSIPURI
from .sdp cimport FrozenSDPSession
from .request cimport EndpointAddress
from .ua cimport PJSIPUA, Timer
from .util cimport PJSTR

cdef class SDPPayloads:
    cdef readonly FrozenSDPSession proposed_local
    cdef readonly FrozenSDPSession proposed_remote
    cdef readonly FrozenSDPSession active_local
    cdef readonly FrozenSDPSession active_remote

cdef class StateCallbackTimer(Timer):
    cdef object state
    cdef object sub_state
    cdef object rdata
    cdef object tdata
    cdef object originator

cdef class SDPCallbackTimer(Timer):
    cdef int status
    cdef object active_local
    cdef object active_remote

cdef class TransferStateCallbackTimer(Timer):
    cdef object state
    cdef object code
    cdef object reason

cdef class TransferResponseCallbackTimer(Timer):
    cdef object method
    cdef object rdata

cdef class TransferRequestCallbackTimer(Timer):
    cdef object rdata

cdef class Invitation(object):
    # attributes
    cdef object __weakref__
    cdef object weakref
    cdef int _sdp_neg_status
    cdef int _failed_response
    cdef pj_list _route_set
    cdef pj_mutex_t *_lock
    cdef pjsip_inv_session *_invite_session
    cdef pjsip_evsub *_transfer_usage
    cdef pjsip_role_e _transfer_usage_role
    cdef pjsip_dialog *_dialog
    cdef pjsip_route_hdr _route_header
    cdef pjsip_transaction *_reinvite_transaction
    cdef PJSTR _sipfrag_payload
    cdef Timer _timer
    cdef Timer _transfer_timeout_timer
    cdef Timer _transfer_refresh_timer
    cdef readonly str call_id
    cdef readonly str direction
    cdef readonly str remote_user_agent
    cdef readonly str state
    cdef readonly str sub_state
    cdef readonly str transport
    cdef readonly str transfer_state
    cdef readonly EndpointAddress peer_address
    cdef readonly FrozenCredentials credentials
    cdef readonly FrozenContactHeader local_contact_header
    cdef readonly FrozenContactHeader remote_contact_header
    cdef readonly FrozenFromHeader from_header
    cdef readonly FrozenToHeader to_header
    cdef readonly FrozenSIPURI request_uri
    cdef readonly FrozenRouteHeader route_header
    cdef readonly SDPPayloads sdp

    # private methods
    cdef int init_incoming(self, PJSIPUA ua, pjsip_rx_data *rdata, unsigned int inv_options) except -1
    cdef int process_incoming_transfer(self, PJSIPUA ua, pjsip_rx_data *rdata) except -1
    cdef int process_incoming_options(self, PJSIPUA ua, pjsip_rx_data *rdata) except -1
    cdef PJSIPUA _check_ua(self)
    cdef int _do_dealloc(self) except -1
    cdef int _update_contact_header(self, BaseContactHeader contact_header) except -1
    cdef int _fail(self, PJSIPUA ua) except -1
    cdef int _cb_state(self, StateCallbackTimer timer) except -1
    cdef int _cb_sdp_done(self, SDPCallbackTimer timer) except -1
    cdef int _cb_timer_disconnect(self, timer) except -1
    cdef int _cb_postpoll_fail(self, timer) except -1
    cdef int _start_incoming_transfer(self, timer) except -1
    cdef int _terminate_transfer(self) except -1
    cdef int _terminate_transfer_uac(self) except -1
    cdef int _terminate_transfer_uas(self) except -1
    cdef int _set_transfer_state(self, str state) except -1
    cdef int _set_sipfrag_payload(self, int code, str reason) except -1
    cdef int _send_notify(self) except -1
    cdef int _transfer_cb_timeout_timer(self, timer) except -1
    cdef int _transfer_cb_refresh_timer(self, timer) except -1
    cdef int _transfer_cb_state(self, TransferStateCallbackTimer timer) except -1
    cdef int _transfer_cb_response(self, TransferResponseCallbackTimer timer) except -1
    cdef int _transfer_cb_notify(self, TransferRequestCallbackTimer timer) except -1
    cdef int _transfer_cb_server_timeout(self, timer) except -1

cdef void _Invitation_cb_state(pjsip_inv_session *inv, pjsip_event *e) with gil
cdef void _Invitation_cb_sdp_done(pjsip_inv_session *inv, int status) with gil
cdef int _Invitation_cb_rx_reinvite(pjsip_inv_session *inv, pjmedia_sdp_session_ptr_const offer, pjsip_rx_data *rdata) with gil
cdef void _Invitation_cb_tsx_state_changed(pjsip_inv_session *inv, pjsip_transaction *tsx, pjsip_event *e) with gil
cdef void _Invitation_cb_new(pjsip_inv_session *inv, pjsip_event *e) with gil
cdef void _Invitation_transfer_cb_state(pjsip_evsub *sub, pjsip_event *event) with gil
cdef void _Invitation_transfer_cb_tsx(pjsip_evsub *sub, pjsip_transaction *tsx, pjsip_event *event) with gil
cdef void _Invitation_transfer_cb_notify(pjsip_evsub *sub, pjsip_rx_data *rdata, int *p_st_code,
                                         pj_str_t **p_st_text, pjsip_hdr *res_hdr, pjsip_msg_body **p_body) with gil
cdef void _Invitation_transfer_cb_refresh(pjsip_evsub *sub) with gil
cdef void _Invitation_transfer_in_cb_rx_refresh(pjsip_evsub *sub, pjsip_rx_data *rdata, int *p_st_code,
                                                pj_str_t **p_st_text, pjsip_hdr *res_hdr, pjsip_msg_body **p_body) with gil
cdef void _Invitation_transfer_in_cb_server_timeout(pjsip_evsub *sub) with gil

# Globals
#

cdef pjsip_inv_callback _inv_cb
