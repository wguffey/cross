# Setup

```bash
git clone https://github.com/you/mochi-analytics.git
cd mochi-analytics

# 1) create venv (choose one)
python -m venv ~/.venvs/mochi        # or: python -m venv .venv

# 2) activate
source ~/.venvs/mochi/bin/activate   # or: source .venv/bin/activate

# 3) install deps
pip install -r requirements.txt
cp .env.example .env   # add your credentials
python -m mochi_etl.etl
```
