# cython: language_level=3

from ._pjsip cimport char_ptr_const, pj_mutex_t
from .ua cimport PJSIPUA

cdef struct _core_event
cdef struct _handler
cdef struct _handler_queue:
    _handler *head
    _handler *tail


cdef int _event_queue_append(_core_event *event)
cdef void _cb_log(int level, char_ptr_const data, int len)
cdef int _add_event(object event_name, dict params) except -1
cdef list _get_clear_event_queue()
cdef int _add_handler(int func(object obj) except -1, object obj, _handler_queue *queue) except -1
cdef int _remove_handler(object obj, _handler_queue *queue) except -1
cdef int _process_handler_queue(PJSIPUA ua, _handler_queue *queue) except -1

cdef pj_mutex_t *_event_queue_lock
cdef _handler_queue _post_poll_handler_queue
cdef _handler_queue _dealloc_handler_queue
