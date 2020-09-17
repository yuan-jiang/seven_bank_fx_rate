### v1.0.0
- Initial release

### v1.1.0
- Switched unnecessary instance variables in `SevenBankFxRate::Parser` to local ones
- Fixed `SevenBankFxRate::respond_to_missing` to strictly check missing method pattern
- Added mutex to avoid extra http requests due to race condition with multiple threads
