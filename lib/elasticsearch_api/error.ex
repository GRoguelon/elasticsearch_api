defmodule ElasticsearchApi.Error do
  defexception [:status, :type, :reason, :root_cause]

  @impl true
  def exception(%{"error" => %{"reason" => reason, "root_cause" => root_cause, "type" => type}, "status" => status}) do
    %__MODULE__{status: status, type: type, reason: reason, root_cause: root_cause}
  end

  @impl true
  def message(%__MODULE__{reason: reason}) do
    reason
  end
end
