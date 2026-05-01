import pandas as pd

df = pd.read_csv("data/loan_data.csv")

assert df.isnull().sum().sum() == 0, "Missing values found!"
assert (df["income"] > 0).all(), "Invalid income!"

print("Data validation passed")
