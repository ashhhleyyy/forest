{ config, pkgs, ... }: {
  services.asterisk = {
    enable = true;
    confFiles = {
      "pjsip.conf" = ''
      [transport-defaults](!)
      type = transport
      bind = 0.0.0.0

      local_net = 127.0.0.0/8
      local_net = 10.0.0.0/8
      local_net = 172.16.0.0/12
      local_net = 192.168.0.0/16

      [transport-udp](transport-defaults)
      protocol = udp

      [transport-tcp](transport-defaults)
      protocol = tcp
      '';

      "rtp.conf" = ''
      [general]
      rtpstart=20000
      rtpend=20999
      '';

      "pjsip_wizard.conf" = ''
      [extension-defaults](!)
      type = wizard
      accepts_registrations = yes
      accepts_auth = yes
      aor/remove_existing = yes
      aor/max_contacts = 1
      aor/qualify_timeout = 3.0
      endpoint/allow = !all,g722,ulaw
      endpoint/subscribe_context = subscribe
      endpoint/context = from-internal
      endpoint/mailboxes = 6000@default

      [6001](extension-defaults)
      endpoint/callerid = Fern <6001>
      inbound_auth/username = 6001
      inbound_auth/password = 3303a8dc75771f8a4d653223fbb8f2f1
      aor/qualify_frequency = 30
      endpoint/direct_media = yes

      [6002](extension-defaults)
      endpoint/callerid = Lyra <6002>
      inbound_auth/username = 6002
      inbound_auth/password = dc18253d8af6af4d5ab36d76e8825d54
      aor/qualify_frequency = 0
      endpoint/direct_media = no
      '';

      "voicemail.conf" = ''
      [general]
      format = wav49|gsm|wav
      serveremail=asterisk-noreply@ashhhleyyy.dev
      attach=yes
      maxmsg = 100
      maxsecs = 300
      maxgreet = 60
      skipms = 3000
      maxsilence = 10
      silencethreshold = 128
      maxlogins = 3
      emailsubject = New voicemail ''${VM_MSGNUM} in mailbox ''${VM_MAILBOX}
      emailbody = Hi ''${VM_NAME},\n\nYou have a new voicemail in mailbox ''${VM_MAILBOX}.\n\nFrom: ''${VM_CALLERID}\nDate: ''${VM_DATE}\nDuration: ''${VM_DUR}\nMessage Number: ''${VM_MSGNUM}
      emaildateformat = %A, %B %d, %Y at %r
      tz = myzone
      locale = en_US.UTF-8
      minpassword = 4

      [zonemessages]
      myzone = Europe/London|'vm-received' Q 'digits/at' IMp

      [default]
      6000 => 1234,Ashley B,ash@ashhhleyyy.dev,,,
      '';

      "queues.conf" = ''
      [general]
      persistentmembers = yes
      autofill = yes
      monitor-type = MixMonitor
      shared_lastcall = yes
      log_membername_as_agent = yes

      [internal-phones]
      strategy = ringall
      timeout = 30
      announce-frequency = 0
      announce-holdtime = no
      announce-position = no
      periodic-announce-frequency = 0
      joinempty = yes
      leavewhenempty = no
      ringinuse = yes

      member => PJSIP/6001,0,Fern,PJSIP/6001
      member => PJSIP/6002,0,Lyra,PJSIP/6002
      '';

      "extensions.conf" = ''
      [public]
      exten => _X.,1,Hangup(3)
      [default]
      exten => _X.,1,Hangup(3)

      [globals]
      VOICEMAIL_NUMBER = *99
      VOICEMAIL_BOX = 6000@default
      VOICEMAIL_RING_TIMEOUT = 25
      HOME_QUEUE = internal-phones
      INTERCOM = 6000
      LOCAL_EXTS = _6XXX

      [subscribe]
      exten => _XXXX,hint,PJSIP/''${EXTEN}

      [gosub-intercom]
      exten => s,1,Set(PJSIP_HEADER(add,Alert-Info)=auto answer)
      same => n,Return()

      [from-internal]
      exten => ''${INTERCOM},1,Set(CALLERID(all)=Intercom <''${EXTEN}>
      same => n,Page(''${STRREPLACE(QUEUE_MEMBER_LIST(''${HOME_QUEUE}),",","&")},db(gosub-intercom^s^1),10)
      same => n,Hangup()

      exten => ''${LOCAL_EXTS},1,Dial(PJSIP/''${EXTEN})
      same => n,Hangup()

      exten => ''${VOICEMAIL_NUMBER},1,Answer(500)
      same => n,VoiceMailMain(''${VOICEMAIL_BOX},s)
      same => n,Hangup()
      '';
    };
  };
}
