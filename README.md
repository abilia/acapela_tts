# acapela_tts

## Getting Started

Add the following line to the android proguard rules to avoid it removing the classes:

> -keep class com.acapelagroup.** { *; }

## Running the example

To run the example two files needs to be added in /example/assets/

1. acapela_license
containing license info:

> 0x01234567
0x89abcdef
"123 4 XXX #TYPE#Company"
KeyKeyKeyKeyKeyKeyKeyKeyKeyKeyKeyKeyKeyKeyKeyKeyKeyKeyKeyKeyKey
KeyKeyKeyKeyKeyKeyKeyKeyKeyKeyKeyKeyKeyKeyKey
KeyKeyKeyKeyKeyKeyKeyKeyKeyKeyKeyKey

2. voices_endpoint
endpoint to download voices:
> <http://url.to/voices>
