# -*- coding: utf-8 -*-
from __future__ import absolute_import
import logging
import os
import salt.utils

log = logging.getLogger(__name__)

HAS_WMI = False
if salt.utils.is_windows():
    try:
        import wmi
        import salt.utils.winapi
        HAS_WMI = True
    except ImportError:
        log.exception('Unable to import Python wmi module; the osinstalltype grain will be missing.')

def windows_installation_type():
    '''
    Determine the Windows Server installation type, i.e., Standard or
    Server Core.
    '''
    if not HAS_WMI:
        return {}

    grains = {}
    with salt.utils.winapi.Com():
        wmi_c = wmi.WMI()
        osinfo = wmi_c.Win32_OperatingSystem()[0]

        ## This only applies to Windows Server 2008 or newer.
        if int(osinfo.Version.split('.')[0]) < 6:
            return {}

        ## This only applies to server-based operating systems.
        if osinfo.ProductType < 2:
            return {}

        ## A simple hack---"%windir%\explorer.exe" does not exist on
        ## Server Core.  This must be revised with the release of
        ## vNext Server, which adds a "Nano Server" install type.
        if not os.path.isfile(os.sep.join([os.environ['windir'], "explorer.exe"])):
            grains['osinstalltype'] = 'Server Core'
        else:
            grains['osinstalltype'] = 'Standard'
    return grains
