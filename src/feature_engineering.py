import pandas as pd

df = pd.read_csv("data/cleaned_data.csv")

df["dti"] = df["loan_amount"] / df["income"]

df.to_csv("data/processed_data.csv", index=False)

print("✅ Features created")
