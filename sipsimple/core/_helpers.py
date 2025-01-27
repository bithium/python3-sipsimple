
"""Miscellaneous SIP related helpers"""

import random
import socket
import string

from application.python.types import MarkerType
from application.system import host

from sipsimple.core._pjsip import SIPURI
from sipsimple.core._engine import Engine


__all__ = ['Route', 'ContactURIFactory', 'NoGRUU', 'PublicGRUU', 'TemporaryGRUU', 'PublicGRUUIfAvailable', 'TemporaryGRUUIfAvailable']


class Route(object):
    _default_ports = dict(udp=5060, tcp=5060, tls=5061)

    def __init__(self, address, port=None, transport='udp', tls_name=None):
        self.address = address.decode() if isinstance(address, bytes) else address
        self.transport = transport.decode() if isinstance(transport, bytes) else transport
        self.tls_name = tls_name.decode() if isinstance(tls_name, bytes) else tls_name
        self.port = port

    @property
    def address(self):
        return self._address

    @address.setter
    def address(self, address):
        try:
            socket.inet_aton(address)
        except:
            raise ValueError('illegal address: %s' % address)
        self._address = address

    @property
    def port(self):
        if self._port is None:
            return 5061 if self.transport == 'tls' else 5060
        else:
            return self._port

    @port.setter
    def port(self, port):
        port = int(port) if port is not None else None
        if port is not None and not (0 < port < 65536):
            raise ValueError('illegal port value: %d' % port)
        self._port = port

    @property
    def transport(self):
        return self._transport

    @transport.setter
    def transport(self, transport):
        if transport not in ('udp', 'tcp', 'tls'):
            raise ValueError('illegal transport value: %s' % transport)
        self._transport = transport

    @property
    def uri(self):
        port = None if self._default_ports[self.transport] == self.port else self.port
        parameters = {} if self.transport == 'udp' else {'transport': self.transport.encode()}
        if self.transport == 'tls':
            parameters['tls_name'] = self.tls_name.encode() if self.tls_name else None
        return SIPURI(host=self.address, port=port, parameters=parameters)

    def __repr__(self):
        return '{0.__class__.__name__}({0.address!r}, port={0.port!r}, transport={0.transport!r}, tls_name={0.tls_name!r})'.format(self)

    def __str__(self):
        return str(self.uri)


class ContactURIType(MarkerType): pass

class NoGRUU(metaclass=ContactURIType):                   pass
class PublicGRUU(metaclass=ContactURIType):               pass
class TemporaryGRUU(metaclass=ContactURIType):            pass
class PublicGRUUIfAvailable(metaclass=ContactURIType):    pass
class TemporaryGRUUIfAvailable(metaclass=ContactURIType): pass


class ContactURIFactory(object):
    def __init__(self, username=None):
        self.username = username or ''.join(random.sample(string.digits, 8))
        self.public_gruu = None
        self.temporary_gruu = None

    def __repr__(self):
        return '{0.__class__.__name__}(username={0.username!r})'.format(self)

    def __getitem__(self, key):
        if isinstance(key, tuple):
            contact_type, key = key
            if not isinstance(contact_type, ContactURIType):
                raise KeyError("unsupported contact type: %r" % contact_type)
        else:
            contact_type = NoGRUU
        if not isinstance(key, (str, Route)):
            raise KeyError("key must be a transport name or Route instance")

        transport = key if isinstance(key, str) else key.transport
        parameters = {} if transport == 'udp' else {'transport': transport}

        if contact_type is PublicGRUU:
            if self.public_gruu is None:
                raise KeyError("could not get Public GRUU")
            uri = SIPURI.new(self.public_gruu)
        elif contact_type is TemporaryGRUU:
            if self.temporary_gruu is None:
                raise KeyError("could not get Temporary GRUU")
            uri = SIPURI.new(self.temporary_gruu)
        elif contact_type is PublicGRUUIfAvailable and self.public_gruu is not None:
            uri = SIPURI.new(self.public_gruu)
        elif contact_type is TemporaryGRUUIfAvailable and self.temporary_gruu is not None:
            uri = SIPURI.new(self.temporary_gruu)
        else:
            ip = host.default_ip if isinstance(key, str) else host.outgoing_ip_for(key.address)
            if ip is None:
                raise KeyError("could not get outgoing IP address")
            port = getattr(Engine(), '%s_port' % transport, None)
            if port is None:
                raise KeyError("unsupported transport: %s" % transport)
            uri = SIPURI(user=self.username, host=ip, port=port)
        uri.parameters.update(parameters)
        return uri


