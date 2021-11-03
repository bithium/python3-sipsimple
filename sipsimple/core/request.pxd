# cython: language_level=3

from ._pjsip cimport (
    pj_timer_entry,
    pj_timer_heap_t,
    pjsip_auth_clt_sess,
    pjsip_event,
    pjsip_route_hdr,
    pjsip_rx_data,
    pjsip_transaction,
    pjsip_tx_data,
)
from .helper cimport (
    FrozenCredentials,
    FrozenSIPURI,
)
from .headers cimport (
    FrozenContactHeader,
    FrozenFromHeader,
    FrozenRouteHeader,
    FrozenToHeader,
)
from .ua cimport PJSIPUA
from .util cimport (
    PJSTR,
    frozenlist,
)

cdef class EndpointAddress(object):
    # attributes
    cdef readonly bytes ip
    cdef readonly int port

cdef class Request(object):
    # attributes
    cdef readonly object state
    cdef PJSTR _method
    cdef readonly EndpointAddress peer_address
    cdef readonly FrozenCredentials credentials
    cdef readonly FrozenFromHeader from_header
    cdef readonly FrozenToHeader to_header
    cdef readonly FrozenSIPURI request_uri
    cdef readonly FrozenContactHeader contact_header
    cdef readonly FrozenRouteHeader route_header
    cdef PJSTR _call_id
    cdef readonly int cseq
    cdef readonly frozenlist extra_headers
    cdef PJSTR _content_type
    cdef PJSTR _content_subtype
    cdef PJSTR _body
    cdef pjsip_tx_data *_tdata
    cdef pjsip_transaction *_tsx
    cdef pjsip_auth_clt_sess _auth
    cdef pjsip_route_hdr _route_header
    cdef int _need_auth
    cdef pj_timer_entry _timer
    cdef int _timer_active
    cdef int _expire_rest
    cdef object _expire_time
    cdef object _timeout

    # private methods
    cdef PJSIPUA _get_ua(self)
    cdef int _cb_tsx_state(self, PJSIPUA ua, pjsip_rx_data *rdata) except -1
    cdef int _cb_timer(self, PJSIPUA ua) except -1

cdef class IncomingRequest(object):
    # attributes
    cdef readonly str state
    cdef pjsip_transaction *_tsx
    cdef pjsip_tx_data *_tdata
    cdef readonly EndpointAddress peer_address

    # methods
    cdef int init(self, PJSIPUA ua, pjsip_rx_data *rdata) except -1

cdef void _Request_cb_tsx_state(pjsip_transaction *tsx, pjsip_event *event) with gil
cdef void _Request_cb_timer(pj_timer_heap_t *timer_heap, pj_timer_entry *entry) with gil
