import pandas as pd


path = r'C:\Users\Dell\Desktop\magisterka\sem2\SSI\players.csv'

data = pd.read_csv(path)
print(data.head)

columns_to_remove = ['Cmp_x_x', 'Min', 'Gls', 'Ast', 'CrdY', 'CrdR', 'Cmp_x_y']


data = data.drop(columns=columns_to_remove)
data.to_csv(r'C:\Users\Dell\Desktop\magisterka\sem2\SSI\players_1.csv', index=False)