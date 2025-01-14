//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#pragma once

#include "ArrayIntegratedBC.h"

class ArrayPenaltyDirichletBC;

template <>
InputParameters validParams<ArrayPenaltyDirichletBC>();

class ArrayPenaltyDirichletBC : public ArrayIntegratedBC
{
public:
  ArrayPenaltyDirichletBC(const InputParameters & parameters);

protected:
  virtual RealEigenVector computeQpResidual() override;
  virtual RealEigenVector computeQpJacobian() override;

private:
  Real _p;
  const RealEigenVector & _v;
};
