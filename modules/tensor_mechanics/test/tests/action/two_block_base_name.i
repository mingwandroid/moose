[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 4
  ny = 4
[]

[MeshModifiers]
  [./block1]
    type = SubdomainBoundingBox
    block_id = 1
    bottom_left = '0 0 0'
    top_right = '0.5 1 0'
  [../]
  [./block2]
    type = SubdomainBoundingBox
    block_id = 2
    bottom_left = '0.5 0 0'
    top_right = '1 1 0'
  [../]
[]

[GlobalParams]
  displacements = 'disp_x disp_y'
[]

[Modules/TensorMechanics/Master]
  # parameters that apply to all subblocks are specified at this level. They
  # can be overwritten in the subblocks.
  add_variables = true
  strain = FINITE
  generate_output = 'stress_xx'
  # base_name can be specified inside or outside a block
  base_name = 'block1'

  [./block1]
    # the `block` parameter is only valid insde a subblock.
    block = 1
  [../]
  [./block2]
    block = 2
    # the `additional_generate_output` parameter is also only valid inside a
    # subblock. Values specified here are appended to the `generate_output`
    # parameter values.
    additional_generate_output = 'strain_yy'
    base_name = 'block2'
  [../]
[]

[AuxVariables]
  [./stress_theta]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./strain_theta]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[AuxKernels]
  [./stress_theta]
    type = RankTwoAux
    block = 1
    rank_two_tensor = block1_stress
    index_i = 2
    index_j = 2
    variable = stress_theta
    execute_on = timestep_end
  [../]
  [./strain_theta]
    type = RankTwoAux
    block = 2
    rank_two_tensor = block2_total_strain
    index_i = 2
    index_j = 2
    variable = strain_theta
    execute_on = timestep_end
  [../]
[]

[Materials]
  [./elasticity_tensor_1]
    type = ComputeIsotropicElasticityTensor
    block = 1
    base_name = block1
    youngs_modulus = 1e10
    poissons_ratio = 0.345
  [../]
  [./elasticity_tensor_2]
    type = ComputeIsotropicElasticityTensor
    block = 2
    base_name = block2
    youngs_modulus = 1e10
    poissons_ratio = 0.345
  [../]
  [./_elastic_stress1]
    type = ComputeFiniteStrainElasticStress
    block = 1
    base_name = block1
  [../]
  [./_elastic_stress2]
    type = ComputeFiniteStrainElasticStress
    block = 2
    base_name = block2
  [../]
[]

[BCs]
  [./left]
    type = PresetBC
    boundary = 'left'
    variable = disp_x
    value = 0.0
  [../]
  [./top]
    type = PresetBC
    boundary = 'top'
    variable = disp_y
    value = 0.0
  [../]
  [./right]
    type = PresetBC
    boundary = 'right'
    variable = disp_x
    value = 0.01
  [../]
  [./bottom]
    type = PresetBC
    boundary = 'bottom'
    variable = disp_y
    value = 0.01
  [../]
[]

[Debug]
  show_var_residual_norms = true
[]

[Executioner]
  type = Steady

  petsc_options_iname = '-ksp_gmres_restart -pc_type -pc_hypre_type -pc_hypre_boomeramg_max_iter'
  petsc_options_value = '  201               hypre    boomeramg      10'

  line_search = 'none'

  nl_rel_tol = 5e-9
  nl_abs_tol = 1e-10
  nl_max_its = 15

  l_tol = 1e-3
  l_max_its = 50
[]

[Outputs]
  exodus = true
[]
