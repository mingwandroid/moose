[Mesh]
  type = GeneratedMesh
  dim = 3
  xmin = 0
  xmax = 5
  nx = 5

  ymin = 0
  ymax = 5
  ny = 5

  zmin = 0
  zmax = 5
  nz = 5
[]

[MeshModifiers]
  [./blocks]
    type = SubdomainBoundingBox
    block_id = 1
    bottom_left = '1 1 0'
    top_right = '4 4 5'
  [../]
[]

[AuxVariables]
  [./from_sub_app_var]
    order = CONSTANT
    family = MONOMIAL
    block = 1
    initial_condition = 0
  [../]
[]

[Variables]
  [u]
  []
[]

[Kernels]
  [diff]
    type = Diffusion
    variable = u
  []
  [td]
    type = TimeDerivative
    variable = u
  []
[]

[BCs]
  [left]
    type = DirichletBC
    variable = u
    boundary = front
    value = -1
  []
  [right]
    type = DirichletBC
    variable = u
    boundary = back
    value = 1
  []
[]

[Executioner]
  type = Transient
  num_steps = 2
  dt = 5

  solve_type = 'NEWTON'
  l_tol = 1e-8
  nl_rel_tol = 1e-10
[]

[Outputs]
  exodus = true
  execute_on = final
[]

[MultiApps]
  [sub_app]
    type = TransientMultiApp
    positions = '0 0 0'
    input_files = two_pipe_sub.i
    app_type = MooseTestApp
    execute_on = TIMESTEP_END
  []
[]

[Transfers]
  [layered_transfer_from_sub_app]
    type = MultiAppUserObjectTransfer
    direction = from_multiapp
    user_object = sub_app_uo
    variable = from_sub_app_var
    multi_app = sub_app
    displaced_source_mesh = true
    skip_bounding_box_check = true
  []
[]
