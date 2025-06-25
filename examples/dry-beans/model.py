"""Fit the dry beans model to a a decision tree model for demonstration purposes."""

CONFIG_FILENAME = "dry-beans-config.yaml"
MODEL_ARTIFACT_FILENAME = "dt_model.pkl"


def loadConfig() -> dict:
    import yaml

    with open(CONFIG_FILENAME, "r") as fin:
        return yaml.safe_load(fin)


def fit():
    print("Initializing...", flush=True)
    import google.cloud.bigquery
    import sklearn.model_selection
    import sklearn.tree
    import pickle
    import pprint

    # Load our config file:
    config = loadConfig()
    print(f"\n{pprint.pformat(config)}\n")

    # Get our dataset:
    sql = f"""\
select
  *
from
  `{config["project_id"]}.{config["dataset_id"]}.{config["table"]}`
"""
    print(sql, flush=True)
    client = google.cloud.bigquery.Client()
    df = client.query_and_wait(sql).to_dataframe()
    print("Dataframe loaded.", flush=True)

    # Create our train / test split:
    labels = df.pop("class").tolist()
    data = df.values.tolist()
    x_train, x_test, y_train, y_test = sklearn.model_selection.train_test_split(
        data, labels
    )

    print("Fitting model...", flush=True)
    dt_model = sklearn.tree.DecisionTreeClassifier()
    dt_model.fit(x_train, y_train)

    print("Scoring model...", flush=True)
    accuracy = dt_model.score(x_test, y_test)
    print(f"Accuracy: {accuracy:.3}")

    print(f"Writing model: {MODEL_ARTIFACT_FILENAME}", flush=True)
    with open(MODEL_ARTIFACT_FILENAME, "wb") as fout:
        pickle.dump(dt_model, fout)

    print("Fit complete.", flush=True)


def runAll():
    fit()


if __name__ == "__main__":
    runAll()
