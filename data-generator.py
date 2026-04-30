import pandas as pd
import numpy as np

np.random.seed(42)

data = pd.DataFrame({
    "income": np.random.randint(20000, 100000, 500),
    "loan_amount": np.random.randint(5000, 50000, 500),
    "credit_score": np.random.randint(300, 850, 500),
})

# Simple rule-based risk label
conditions = [
    (data["credit_score"] > 700),
    (data["credit_score"] > 500)
]
choices = ["Low", "Medium"]

data["risk"] = np.select(conditions, choices, default="High")

data.to_csv("data/loan_data.csv", index=False)

print("Dataset generated!")