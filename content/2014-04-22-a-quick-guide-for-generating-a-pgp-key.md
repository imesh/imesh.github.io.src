---
author: imesh
comments: true
date: 2014-04-22 04:27:26+00:00
layout: post
slug: a-quick-guide-for-generating-a-pgp-key
title: A Quick-Guide for Generating a PGP Key
wordpress_id: 81
categories:
- Blog
tags:
- security
---

#### 1. Generate a Self Signed Key



[code] $ gpg --gen-key [/code]

[code]
gpg (GnuPG) 1.4.10; Copyright (C) 2008 Free Software Foundation, Inc.
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Please select what kind of key you want:
   (1) RSA and RSA (default)
   (2) DSA and Elgamal
   (3) DSA (sign only)
   (4) RSA (sign only)
Your selection? 1
[/code]

[code]
RSA keys may be between 1024 and 4096 bits long.
What keysize do you want? (2048) 4096
Requested keysize is 4096 bits
Please specify how long the key should be valid.
         0 = key does not expire
      <n>  = key expires in n days
      <n>w = key expires in n weeks
      <n>m = key expires in n months
      <n>y = key expires in n years
Key is valid for? (0) 
Key does not expire at all
Is this correct? (y/N) y
[/code]

[code]
You need a user ID to identify your key; the software constructs the user ID
from the Real Name, Comment and Email Address in this form:
    "First-Name Last-Name <your-id@domain.org>"

Real name: Robert First-Name Last-Name 
Email address: your-id@apache.org
Comment: CODE SIGNING KEY
You selected this USER-ID:
    "First-Name Last-Name (CODE SIGNING KEY) <your-id@apache.org>"
[/code]

[code]
Change (N)ame, (C)omment, (E)mail or (O)kay/(Q)uit? O
You need a Passphrase to protect your secret key.
[/code]



#### 2. Check that SHA1 is Avoided



[code] $ gpg --edit-key KEY-ID [/code]

[code]
gpg (GnuPG) 1.4.10; Copyright (C) 2008 Free Software Foundation, Inc.
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Secret key is available.

pub  4096R/<KEY-ID>  created: 2010-02-16  expires: never       usage: SC  
                     trust: ultimate      validity: ultimate
sub  4096R/436E0F7C  created: 2010-02-16  expires: never       usage: E   
ultimate (1). First-Name Last-Name (CODE SIGNING KEY) <user-id@apache.org>
[/code]

[code] Command> showpref [/code]

[code]
ultimate (1). First-Name Last-Name (CODE SIGNING KEY)
<user-id@apache.org>
     Cipher: AES256, AES192, AES, CAST5, 3DES
     Digest: SHA512, SHA384, SHA256, SHA224, SHA1
     Compression: ZLIB, BZIP2, ZIP, Uncompressed
     Features: MDC, Keyserver no-modify
[/code]

Here SHA1 should appear last in the Digest section. If not enter below command to correct the order:

[code] Command> setpref SHA512 SHA384 SHA256 SHA224 AES256 AES192 AES CAST5 ZLIB BZIP2 ZIP Uncompressed [/code]



#### 3. Export the Private Key



Export and keep the private key in a secure location:

[code] $ gpg --export-secret-keys --armor --output private-key.sec [/code]



#### 4. Export the Public Key



Export the public key:

[code] $ gpg --export --armor --output public-key.asc [/code]



#### 5. Send the Public Key to a Server



Send the public key to a preferred key server (pgp.mit.edu, pgpkeys.telering.at, pgp.surfnet.nl, etc):

[code] $ gpg --keyserver SERVER-HOST --send-keys KEY-ID [/code]
 

**References:**

[1] http://www.apache.org/dev/release-signing.html
[2] http://www.pgpi.org/doc/pgpintro/
[3] http://www.apache.org/dev/openpgp.html
[4] http://people.apache.org/~henkp/trust/
