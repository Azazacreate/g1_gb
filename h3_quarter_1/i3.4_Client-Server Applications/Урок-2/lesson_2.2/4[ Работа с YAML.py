import yaml
with open('data_read.yaml') as f_n:
    f_n_content = yaml.load(f_n)
print(f_n_content)
