defmodule Mnist.NeuralNetwork do
  require Axon

  alias Mnist.DataSet

  def neural_network() do
    Axon.input({nil, 28, 28})
    |> Axon.flatten()
    |> Axon.dense(128, activation: :sigmoid)
    |> Axon.dense(10, activation: :softmax)
  end

  def train_batch() do
    Nx.to_batched_list(DataSet.training_images(), 32)
  end

  def label_batch() do
    Nx.to_batched_list(DataSet.training_labels(), 32)
  end

  # Mnist.NeuralNetwork.train().(Mnist.NeuralNetwork.train_batch |> List.last) |> Nx.argmax(axis: 1)
  # Mnist.NeuralNetwork.train_batch |> List.last |> Nx.to_heatmap
  def train() do
    neural_network = neural_network()
    data = Enum.zip(train_batch(), label_batch())

    trained_params =
      neural_network
      |> Axon.Loop.trainer(:categorical_cross_entropy, Axon.Optimizers.sgd(0.01))
      |> Axon.Loop.run(data, epochs: 10, compiler: EXLA)

    fn test_data ->
      neural_network
      |> Axon.predict(trained_params, test_data, compiler: EXLA)
    end
  end
end
