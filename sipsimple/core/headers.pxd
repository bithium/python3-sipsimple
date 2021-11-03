# cython: language_level=3

from ._pjsip cimport (
    pj_pool_t,
    pjsip_contact_hdr,
    pjsip_ctype_hdr,
    pjsip_event_hdr,
    pjsip_fromto_hdr,
    pjsip_generic_string_hdr,
    pjsip_replaces_hdr,
    pjsip_retry_after_hdr,
    pjsip_route_hdr,
    pjsip_routing_hdr,
    pjsip_sub_state_hdr,
    pjsip_via_hdr,
)
from .helper cimport FrozenSIPURI, SIPURI
from .util cimport _pj_str_to_str, _pjsip_param_to_dict, frozendict

cdef class BaseHeader(object):
    pass

cdef class Header(BaseHeader):
    # attributes
    cdef str _name
    cdef str _body

cdef class FrozenHeader(BaseHeader):
    # attributes
    cdef readonly str name
    cdef readonly str body

cdef class BaseContactHeader(object):
    pass

cdef class ContactHeader(BaseContactHeader):
    # attributes
    cdef SIPURI _uri
    cdef unicode _display_name
    cdef dict _parameters

cdef class FrozenContactHeader(BaseContactHeader):
    # attributes
    cdef int initialized
    cdef readonly FrozenSIPURI uri
    cdef readonly unicode display_name
    cdef readonly frozendict parameters

cdef class BaseContentTypeHeader(object):
    pass

cdef class ContentTypeHeader(BaseContentTypeHeader):
    # attributes
    cdef str _content_type
    cdef dict _parameters

cdef class FrozenContentTypeHeader(BaseContentTypeHeader):
    # attributes
    cdef int initialized
    cdef readonly str _content_type
    cdef readonly frozendict parameters

cdef class BaseIdentityHeader(object):
    pass

cdef class IdentityHeader(BaseIdentityHeader):
    # attributes
    cdef SIPURI _uri
    cdef public unicode display_name
    cdef dict _parameters

cdef class FrozenIdentityHeader(BaseIdentityHeader):
    # attributes
    cdef int initialized
    cdef readonly FrozenSIPURI uri
    cdef readonly unicode display_name
    cdef readonly frozendict parameters

cdef class FromHeader(IdentityHeader):
    pass

cdef class FrozenFromHeader(FrozenIdentityHeader):
    pass

cdef class ToHeader(IdentityHeader):
    pass

cdef class FrozenToHeader(FrozenIdentityHeader):
    pass

cdef class RouteHeader(IdentityHeader):
    pass

cdef class FrozenRouteHeader(FrozenIdentityHeader):
    pass

cdef class RecordRouteHeader(IdentityHeader):
    pass

cdef class FrozenRecordRouteHeader(FrozenIdentityHeader):
    pass

cdef class BaseRetryAfterHeader(object):
    pass

cdef class RetryAfterHeader(BaseRetryAfterHeader):
    # attributes
    cdef public int seconds
    cdef public str comment
    cdef dict _parameters

cdef class FrozenRetryAfterHeader(BaseRetryAfterHeader):
    # attributes
    cdef int initialized
    cdef readonly int seconds
    cdef readonly str comment
    cdef readonly frozendict parameters

cdef class BaseViaHeader(object):
    pass

cdef class ViaHeader(BaseViaHeader):
    # attributes
    cdef str _transport
    cdef str _host
    cdef int _port
    cdef dict _parameters

cdef class FrozenViaHeader(BaseViaHeader):
    # attributes
    cdef int initialized
    cdef readonly str transport
    cdef readonly str host
    cdef readonly int port
    cdef readonly frozendict parameters

cdef class BaseWarningHeader(object):
    pass

cdef class WarningHeader(BaseWarningHeader):
    # attributes
    cdef int _code
    cdef str _agent
    cdef str _text

cdef class FrozenWarningHeader(BaseWarningHeader):
    # attributes
    cdef int initialized
    cdef readonly int code
    cdef readonly str agent
    cdef readonly str text

cdef class BaseEventHeader(object):
    pass

cdef class EventHeader(BaseEventHeader):
    # attributes
    cdef public event
    cdef dict _parameters

cdef class FrozenEventHeader(BaseEventHeader):
    # attributes
    cdef int initialized
    cdef readonly str event
    cdef readonly frozendict parameters

cdef class BaseSubscriptionStateHeader(object):
    pass

cdef class SubscriptionStateHeader(BaseSubscriptionStateHeader):
    # attributes
    cdef public state
    cdef dict _parameters

cdef class FrozenSubscriptionStateHeader(BaseSubscriptionStateHeader):
    # attributes
    cdef int initialized
    cdef readonly str state
    cdef readonly frozendict parameters

cdef class BaseReasonHeader(object):
    pass

cdef class ReasonHeader(BaseReasonHeader):
    # attributes
    cdef public str protocol
    cdef public dict parameters

cdef class FrozenReasonHeader(BaseReasonHeader):
    # attributes
    cdef int initialized
    cdef readonly str protocol
    cdef readonly frozendict parameters

cdef class BaseReferToHeader(object):
    pass

cdef class ReferToHeader(BaseReferToHeader):
    # attributes
    cdef public str uri
    cdef dict _parameters

cdef class FrozenReferToHeader(BaseReferToHeader):
    # attributes
    cdef int initialized
    cdef readonly str uri
    cdef readonly frozendict parameters

cdef class BaseSubjectHeader(object):
    pass

cdef class SubjectHeader(BaseSubjectHeader):
    # attributes
    cdef public unicode subject

cdef class FrozenSubjectHeader(BaseSubjectHeader):
    # attributes
    cdef int initialized
    cdef readonly unicode subject

cdef class BaseReplacesHeader(object):
    pass

cdef class ReplacesHeader(BaseReplacesHeader):
    # attributes
    cdef public str call_id
    cdef public str from_tag
    cdef public str to_tag
    cdef public int early_only
    cdef dict _parameters

cdef class FrozenReplacesHeader(BaseReplacesHeader):
    # attributes
    cdef int initialized
    cdef readonly str call_id
    cdef readonly str from_tag
    cdef readonly str to_tag
    cdef readonly int early_only
    cdef readonly frozendict parameters

cdef Header Header_create(pjsip_generic_string_hdr *header)
cdef FrozenHeader FrozenHeader_create(pjsip_generic_string_hdr *header)
cdef ContactHeader ContactHeader_create(pjsip_contact_hdr *header)
cdef FrozenContactHeader FrozenContactHeader_create(pjsip_contact_hdr *header)
cdef ContentTypeHeader ContentTypeHeader_create(pjsip_ctype_hdr *header)
cdef FrozenContentTypeHeader FrozenContentTypeHeader_create(pjsip_ctype_hdr *header)
cdef FromHeader FromHeader_create(pjsip_fromto_hdr *header)
cdef FrozenFromHeader FrozenFromHeader_create(pjsip_fromto_hdr *header)
cdef ToHeader ToHeader_create(pjsip_fromto_hdr *header)
cdef FrozenToHeader FrozenToHeader_create(pjsip_fromto_hdr *header)
cdef RouteHeader RouteHeader_create(pjsip_routing_hdr *header)
cdef FrozenRouteHeader FrozenRouteHeader_create(pjsip_routing_hdr *header)
cdef RecordRouteHeader RecordRouteHeader_create(pjsip_routing_hdr *header)
cdef FrozenRecordRouteHeader FrozenRecordRouteHeader_create(pjsip_routing_hdr *header)
cdef RetryAfterHeader RetryAfterHeader_create(pjsip_retry_after_hdr *header)
cdef FrozenRetryAfterHeader FrozenRetryAfterHeader_create(pjsip_retry_after_hdr *header)
cdef ViaHeader ViaHeader_create(pjsip_via_hdr *header)
cdef FrozenViaHeader FrozenViaHeader_create(pjsip_via_hdr *header)
cdef EventHeader EventHeader_create(pjsip_event_hdr *header)
cdef FrozenEventHeader FrozenEventHeader_create(pjsip_event_hdr *header)
cdef SubscriptionStateHeader SubscriptionStateHeader_create(pjsip_sub_state_hdr *header)
cdef FrozenSubscriptionStateHeader FrozenSubscriptionStateHeader_create(pjsip_sub_state_hdr *header)
cdef ReferToHeader ReferToHeader_create(pjsip_generic_string_hdr *header)
cdef FrozenReferToHeader FrozenReferToHeader_create(pjsip_generic_string_hdr *header)
cdef SubjectHeader SubjectHeader_create(pjsip_generic_string_hdr *header)
cdef FrozenSubjectHeader FrozenSubjectHeader_create(pjsip_generic_string_hdr *header)
cdef ReplacesHeader ReplacesHeader_create(pjsip_replaces_hdr *header)
cdef FrozenReplacesHeader FrozenReplacesHeader_create(pjsip_replaces_hdr *header)
cdef int _BaseRouteHeader_to_pjsip_route_hdr(BaseIdentityHeader header, pjsip_route_hdr *pj_header, pj_pool_t *pool) except -1
