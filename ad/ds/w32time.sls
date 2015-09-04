{% from "ad/ds/map.jinja" import ad_ds_settings with context %}

HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time\Parameters\Type:
  reg.present:
    - vtype: REG_SZ
    - value: {{ "NTP" if ad_ds_settings.authoritative_time else "NT5DS" }}

HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time\Config\AnnounceFlags:
  reg.present:
    - vtype: REG_DWORD
    - value: {{ ad_ds_settings.announce_flag if ad_ds_settings.authoritative_time else '0xA' }}

HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time\TimeProviders\NtpServer:
  reg.present:
    - vtype: REG_DWORD
    - value: {{ 1 if ad_ds_settings.authoritative_time else 0 }}

HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time\Parameters\NtpServer:
  reg.present:
    - vtype: REG_SZ
    - value: {{ ad_ds_settings.ntp_peers|join(' ') if ad_ds_settings.authoritative_time else 'time.windows.com,0x1' }}

HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time\TimeProviders\NtpClient\SpecialPollInterval:
  reg.present:
    - vtype: REG_DWORD
    - value: {{ ad_ds_settings.special_poll_interval if ad_ds_settings.authoritative_time else 3600 }}

HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time\Config\MaxPosPhaseCorrection:
  reg.present:
    - vtype: REG_DWORD
    - value: {{ ad_ds_settings.max_pos_phase_correction if ad_ds_settings.authoritative_time else 172800 }}

HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time\Config\MaxNegPhaseCorrection:
  reg.present:
    - vtype: REG_DWORD
    - value: {{ ad_ds_settings.max_pos_phase_correction if ad_ds_settings.authoritative_time else 172800 }}
