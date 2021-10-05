import pandas as pd
import numpy as np
from math import ceil


def preprocessing(data_path, Nbits = 16, class_col = -1, drop_cols = None):

    descriptor_string = []
    df = pd.read_csv(data_path , sep = None)

    if drop_cols is not None:
        df = df.drop(drop_cols, axis = 1)
    df = df.dropna()

    new_names = ['feat_%d' % (i) for i in range(len(df.columns))]
    new_names[class_col] = 'class'

    categories = {}
    new_df = pd.DataFrame()
    new_df_approx = pd.DataFrame()
    NBits_vet = []
    for col, new_col in zip(df.columns, new_names):
        X = df[col]
        if len(X.unique()) < 20:
            cat_col = pd.Categorical(X)
            categories[col] = '%s->%s; ' % ( col, new_col)
            categories[col] += ', '.join(['%s:%s' % (i,j) for i,j in zip(cat_col.categories,dict( enumerate(cat_col.categories ) ).keys())])
            Xt = cat_col.codes
            Xt_approx = Xt
            n_bits = int(ceil(np.log2(np.unique(Xt).shape[0])))
        else:

            categories[col] = '%s->%s; ' % (col, new_col)
            categories[col] += 'numeric'
            Xt = (X-X.min())/(X.max() - X.min()) * (2**(Nbits) - 1)
            Xt_approx = np.floor(Xt).astype(int)
            n_bits = Nbits
            
        categories[col] += " ; %d bits " % (n_bits)
        new_df[new_col] = Xt
        new_df_approx[new_col] = Xt_approx
        NBits_vet.append([new_col, n_bits])

    new_df = new_df.dropna()
    new_df_approx = new_df_approx.dropna()
    new_df.to_csv(rreplace(data_path,'.','_preprocessed.'), index=False)
    new_df_approx.to_csv(rreplace(data_path,'.','_preprocessed_approx.'), index=False)

    descriptor_path = '%s.txt' % ('_'.join(data_path.split('.')[:-1]))
    descriptor_file= open(descriptor_path, 'w')
    descriptor_file.write('\n'.join(categories.values()))
    descriptor_file.close()
    return NBits_vet

def rreplace(s, old, new, count=1):
    return (s[::-1].replace(old[::-1], new[::-1], count))[::-1]


def main():
    data = 'datasets/liver_disorder.csv'
    data = 'datasets/gyroscope.csv'

    drop_cols = {}
    drop_cols["wearable"] = ['user_name', 'raw_timestamp_part_1', 'raw_timestamp_part_2', 'cvtd_timestamp']

    preprocessing(data, drop_cols = drop_cols["wearable"])

if __name__ == "__main__":
    main()
