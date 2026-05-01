import pandas as pd

df = pd.read_csv("data/loan_data.csv")

# Remove duplicates
df = df.drop_duplicates()

# Clip extreme values
df["income"] = df["income"].clip(20000, 100000)

df.to_csv("data/cleaned_data.csv", index=False)

print("✅ Data cleaned")
