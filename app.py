import streamlit as st
from PIL import Image
import numpy as np
from solver import solve
import os

# Get the list of files in the seeds folder
seed_files = os.listdir("seeds")

# Create a sidebar with a select option
selected_seed = st.sidebar.selectbox("Select Seed File", seed_files)

st.markdown("Boundary Condition")
canvas_container = st.empty()

# Create a canvas with a black background
with canvas_container.container():
    st.image(np.zeros((500, 500, 3), dtype=np.uint8))

# Read the selected seed file and insert the image into the canvas when 'apply' is pressed
if st.sidebar.button("Apply"):
    seed_image = Image.open(os.path.join("seeds", selected_seed))
    with canvas_container.container():
        st.image(seed_image)

button = st.button("Go")

st.markdown("---")
st.markdown("Simulation Result")