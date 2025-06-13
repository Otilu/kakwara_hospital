defmodule KakwaraHospitalWeb.Layouts do
  @moduledoc """
  This module holds different layouts used by your application.

  See the `layouts` directory for all templates available.
  The "root" layout is a skeleton rendered as part of the
  application router. The "app" layout is set as the default
  layout on both `use KakwaraHospitalWeb, :controller` and
  `use KakwaraHospitalWeb, :live_view`.
  """
  use KakwaraHospitalWeb, :html

  embed_templates "layouts/*"
end
