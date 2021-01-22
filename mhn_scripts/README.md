# deploy script

Create a new deploy script from the MHN Web Interface and copy the contents from `deploy_miniprint.sh` there

# normalizer integration

### Steps to follow:

1. Copy `miniprint_events.py` in `/opt/opt/mnemosyne/normalizer/modules`
2. Add `miniprint.events` to `channels` variable in `/opt/opt/mnemosyne/mnemosyne.cfg` 
3. Add `from modules import wordpot_events` in `/opt/opt/mnemosyne/normalizer/normalizer.py`
3. Run `supervisorctl restart all` on the mhn server