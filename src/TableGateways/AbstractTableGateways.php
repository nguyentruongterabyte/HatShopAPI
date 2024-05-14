<?php
namespace Src\TableGateways;

abstract class AbstractTableGateways {
  public abstract function update(array $input);
  public abstract function delete($id);

  public abstract function find($id);
  public abstract function create(array $input);
}