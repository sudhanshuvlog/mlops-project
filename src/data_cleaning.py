import pandas as pd
import numpy as np

df = pd.read_csv("data/raw/loan_data.csv")

print("🔹 Initial shape:", df.shape)

# ------------------------
# 1. Remove duplicates
# ------------------------
df = df.drop_duplicates()

# ------------------------
# 2. Handle missing values
# (simulate real-world case)
# ------------------------
df = df.replace([np.inf, -np.inf], np.nan)
df = df.dropna()

# ------------------------
# 3. Remove invalid values
# ------------------------
df = df[
    (df["income"] > 0) &
    (df["loan_amount"] > 0) &
    (df["credit_score"].between(300, 850))
]

# ------------------------
# 4. Remove unrealistic outliers
# ------------------------
df = df[df["loan_amount"] < df["income"] * 5]

# ------------------------
# 5. Feature Engineering
# ------------------------
df["loan_to_income_ratio"] = df["loan_amount"] / df["income"]

# ------------------------
# 6. Encode target
# ------------------------
risk_map = {"Low": 0, "Medium": 1, "High": 2}
df["risk_encoded"] = df["risk"].map(risk_map)

print("🔹 Final cleaned shape:", df.shape)

# Save
df.to_csv("data/processed/cleaned_data.csv", index=False)

print("✅ Cleaned + processed data saved")
