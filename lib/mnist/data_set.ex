defmodule Mnist.DataSet do
  def fetch_image_data() do
    {:ok, {_status, _headers, image_body}} =
      :httpc.request(
        "https://storage.googleapis.com/cvdf-datasets/mnist/train-images-idx3-ubyte.gz"
      )

    image_body
  end

  def fetch_label_data() do
    {:ok, {_status, _headers, label_body}} =
      :httpc.request(
        "https://storage.googleapis.com/cvdf-datasets/mnist/train-labels-idx1-ubyte.gz"
      )

    label_body
  end

  def training_images() do
    <<_::32, n_images::32, n_rows::32, n_cols::32, image_body::binary>> =
      :zlib.gunzip(fetch_image_data())

    image_tensor =
      image_body
      |> Nx.from_binary({:u, 8})
      |> Nx.reshape({n_images, n_rows, n_cols})
      |> Nx.divide(255)

    #Nx.to_heatmap(image_tensor)
    image_tensor
  end

  def training_labels() do
    <<_::32, n_labels::32, label_body::binary>> = :zlib.gunzip(fetch_label_data())

    label_tensor =
      label_body
      |> Nx.from_binary({:u, 8})
      |> Nx.reshape({n_labels, 1})
      |> Nx.equal(Nx.tensor(Enum.to_list(0..9)))
  end
end
