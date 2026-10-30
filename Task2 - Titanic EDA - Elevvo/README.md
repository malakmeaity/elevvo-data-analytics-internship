# Titanic Exploratory Data Analysis

Exploratory data analysis of the Titanic: Machine Learning from Disaster dataset (Kaggle), using Python, Pandas, NumPy, Matplotlib and Seaborn.

## What this project covers
- **Data cleaning:** missing values (Age, Embarked, Cabin), type conversion, new features (FamilySize, IsAlone, AgeGroup, Title)
- **Summary statistics and group insights:** survival by gender, class, age group, port, cabin, family size and title, with chi-square tests
- **Visualizations:** distributions, outliers, survival patterns
- **Correlation analysis:** correlation heatmap with interpretation
- **Bonus:** survival-rate bar plots with confidence intervals and heatmaps (class x gender, age x class, port x class)

## Key findings
- Overall survival was about 38%.
- Sex was the strongest factor: women survived at about 74% vs about 19% for men.
- Class mattered too: 63% survival in 1st class vs 24% in 3rd class.
- Children and small families (2 to 4 people) survived best.
- Cherbourg passengers survived more, largely because more of them were in 1st class.

## Files
| File | Description |
|---|---|
| `Titanic_EDA_final.ipynb` | Full analysis notebook |
| `train.csv` | Original Kaggle data |
| `titanic_cleaned.csv` | Cleaned data produced by the notebook |
| `figures/` | Saved charts |

## How to run
1. Clone or download this repository.
2. Install the libraries: `pip install pandas numpy matplotlib seaborn scipy jupyter`
3. Open `Titanic_EDA_final.ipynb` in Jupyter or Google Colab and run all cells.

## Tools
Python, Pandas, NumPy, Matplotlib, Seaborn, SciPy

## Author

[Malak Meaity](https://linkedin.com/in/malakmeaity)
