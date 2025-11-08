import streamlit as st

st.markdown("""
## 🚀 We've moved!
Please visit our new 👉 [address](http://46.62.247.214:8501)!
""")


# Optional: automatic redirect after 3 seconds
st.markdown("""
<meta http-equiv="refresh" content="3; url=http://46.62.247.214:8501" />
""", unsafe_allow_html=True)
