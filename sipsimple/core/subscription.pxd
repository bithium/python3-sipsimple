# cython: language_level=3

from ._pjsip cimport (
    pj_list,
    pj_str_t,
    pj_time_val,
    pj_timer_entry,
    pjsip_dialog,
    pjsip_event,
    pjsip_evsub,
    pjsip_hdr,
    pjsip_msg_body,
    pjsip_route_hdr,
    pjsip_rx_data,
    pjsip_transaction,
    pjsip_tx_data,
)
from .headers cimport (
    FrozenContactHeader,
    FrozenFromHeader,
    FrozenRouteHeader,
    FrozenToHeader,
)
from .helper cimport FrozenCredentials
from .request cimport EndpointAddress
from .ua cimport PJSIPUA
from .util cimport frozenlist, PJSTR


cdef class Subscription(object):
    # attributes
    cdef pjsip_evsub *_obj
    cdef pjsip_dialog *_dlg
    cdef pjsip_route_hdr _route_header
    cdef pj_list _route_set
    cdef pj_timer_entry _timeout_timer
    cdef int _timeout_timer_active
    cdef pj_timer_entry _refresh_timer
    cdef int _refresh_timer_active
    cdef readonly str state
    cdef readonly EndpointAddress peer_address
    cdef readonly FrozenFromHeader from_header
    cdef readonly FrozenToHeader to_header
    cdef readonly FrozenContactHeader contact_header
    cdef readonly object event
    cdef readonly FrozenRouteHeader route_header
    cdef readonly FrozenCredentials credentials
    cdef readonly int refresh
    cdef readonly frozenlist extra_headers
    cdef readonly object body
    cdef readonly object content_type
    cdef readonly str call_id
    cdef pj_time_val _subscribe_timeout
    cdef int _want_end
    cdef int _term_code
    cdef object _term_reason
    cdef int _expires

    # private methods
    cdef PJSIPUA _get_ua(self)
    cdef int _cancel_timers(self, PJSIPUA ua, int cancel_timeout, int cancel_refresh) except -1
    cdef int _send_subscribe(self, PJSIPUA ua, int expires, pj_time_val *timeout,
                             object extra_headers, object content_type, object body) except -1
    cdef int _cb_state(self, PJSIPUA ua, str state, int code, object reason, dict headers) except -1
    cdef int _cb_got_response(self, PJSIPUA ua, pjsip_rx_data *rdata) except -1
    cdef int _cb_notify(self, PJSIPUA ua, pjsip_rx_data *rdata) except -1
    cdef int _cb_timeout_timer(self, PJSIPUA ua)
    cdef int _cb_refresh_timer(self, PJSIPUA ua)

cdef class IncomingSubscription(object):
    # attributes
    cdef pjsip_evsub *_obj
    cdef pjsip_dialog *_dlg
    cdef PJSTR _content_type
    cdef PJSTR _content_subtype
    cdef PJSTR _content
    cdef pjsip_tx_data *_initial_response
    cdef pjsip_transaction *_initial_tsx
    cdef int _expires
    cdef readonly str state
    cdef readonly object event
    cdef readonly str call_id
    cdef readonly EndpointAddress peer_address

    # methods
    cdef int _set_state(self, str state) except -1
    cdef PJSIPUA _get_ua(self, int raise_exception)
    cdef int init(self, PJSIPUA ua, pjsip_rx_data *rdata, object event) except -1
    cdef int _send_initial_response(self, int code) except -1
    cdef int _send_notify(self, object reason=*) except -1
    cdef int _terminate(self, PJSIPUA ua, object reason, int do_cleanup) except -1
    cdef int _cb_rx_refresh(self, PJSIPUA ua, pjsip_rx_data *rdata) except -1
    cdef int _cb_server_timeout(self, PJSIPUA ua) except -1
    cdef int _cb_tsx(self, PJSIPUA ua, pjsip_event *event) except -1

cdef void _Subscription_cb_state(pjsip_evsub *sub, pjsip_event *event) with gil
cdef void _Subscription_cb_notify(pjsip_evsub *sub, pjsip_rx_data *rdata, int *p_st_code,
                                    pj_str_t **p_st_text, pjsip_hdr *res_hdr, pjsip_msg_body **p_body) with gil
cdef void _Subscription_cb_refresh(pjsip_evsub *sub) with gil
cdef void _IncomingSubscription_cb_rx_refresh(pjsip_evsub *sub, pjsip_rx_data *rdata,
                                              int *p_st_code, pj_str_t **p_st_text,
                                              pjsip_hdr *res_hdr, pjsip_msg_body **p_body) with gil
cdef void _IncomingSubscription_cb_server_timeout(pjsip_evsub *sub) with gil
cdef void _IncomingSubscription_cb_tsx(pjsip_evsub *sub, pjsip_transaction *tsx, pjsip_event *event) with gil
