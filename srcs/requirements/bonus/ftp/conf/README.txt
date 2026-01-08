# Standalone mode
listen=YES

This tells vsftpd to run in standalone mode. Do NOT try and run vsftpd from
an inetd with this option set - it won't work, you may well get 500 OOPS:
could not bind listening socket.

max_clients=200
max_per_ip=4

The maximum number of session is 200 (new clients will get refused with a
busy message). The maximum number of sessions from a single IP is 4 (the
5th connect will get refused with a suitable message).

# Access rights
anonymous_enable=YES
local_enable=NO
write_enable=NO
anon_upload_enable=NO
anon_mkdir_write_enable=NO
anon_other_write_enable=NO

This makes sure the FTP server is in anonymous-only mode and that all write
and upload permissions are disabled. Note that most of these settings are
the same as the default values anyway - but where security is concerned, it
is good to be clear.

# Security
anon_world_readable_only=YES
connect_from_port_20=YES
hide_ids=YES
pasv_min_port=50000
pasv_max_port=60000

These settings, in order
- Make sure only world-readable files and directories are served.
- Originates FTP port connections from a secure port - so users on the FTP
server cannot try and fake file content.
- Hide the FTP server user IDs and just display "ftp" in directory listings.
This is also a performance boost.
- Set a 50000-60000 port range for passive connections - may enable easier
firewall setup!

# Features
xferlog_enable=YES
ls_recurse_enable=NO
ascii_download_enable=NO
async_abor_enable=YES

In order,
- Enables recording of transfer stats to /var/log/vsftpd.log
- Disables "ls -R", to prevent it being used as a DoS attack. Note - sites
wanting to be copied via the "mirror" program might need to enable this.
- Disables downloading in ASCII mode, to prevent it being used as a DoS
attack (ASCII downloads are CPU heavy).
- Enables older FTP clients to cancel in-progress transfers.

# Performance
one_process_model=YES
idle_session_timeout=120
data_connection_timeout=300
accept_timeout=60
connect_timeout=60
anon_max_rate=50000

In order,
- Activates a faster "one process per connection" model. Note! To maintain
security, this feature is only available on systems with capabilities - e.g.
Linux kernel 2.4.
- Boots off idle users after 2 minutes.
- Boots off idle downloads after 5 minutes.
- Boots off hung passive connects after 1 minute.
- Boots off hung active connects after 1 minute.
- Limits a single client to ~50kbytes / sec download speed.

