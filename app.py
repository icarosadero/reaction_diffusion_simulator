import streamlit as st
from PIL import Image
from streamlit_drawable_canvas import st_canvas
import numpy as np
from solver import solve

canvas_result = st_canvas(
    fill_color="rgba(255, 165, 0, 0.3)",  # Fixed fill color with some opacity
    stroke_width=5,
    stroke_color="#ffffff",
    background_color="#000000",
    background_image=None,
    update_streamlit=True,
    height=500,
    width=500,
    drawing_mode="freedraw",
    point_display_radius=0,
    key="canvas",
)

if canvas_result.image_data is not None:
    data = canvas_result.image_data
    #Turn to monochrome
    image = Image.fromarray(data)
    image = image.convert("L")
    data = np.array(image)
    #Renormalize to 0-1
    data = (data - data.min()) / (data.max() - data.min())
    print(data)
    if st.button("Go"):
        result = solve(data)
        print(result)
        #Renormalize to 0-1
        result = (result - result.min()) / (result.max() - result.min())
        st.image(result)