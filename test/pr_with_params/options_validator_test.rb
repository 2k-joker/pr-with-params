require_relative "../test_helper"

class PRWithParams::OptionsValidatorTest < Minitest::Test
  def test_validator_class_mapping
    assert_equal({ conventional_commits: 'PRWithParams::ConventionalCommitValidator' }, PRWithParams::OptionsValidator::VALIDATOR_CLASS_MAP)
    assert_predicate PRWithParams::OptionsValidator::VALIDATOR_CLASS_MAP, :frozen?
  end

  def test_that_it_raises_argument_error_if_validator_undefined
    error = assert_raises(PRWithParams::OptionsValidator::ValidatorError) do
      PRWithParams::OptionsValidator.validate!({}, validators: [:bad_validator])
    end

    assert_equal 'Invalid or undefined validator: bad_validator', error.message
  end

  def test_that_it_validates_good_conventional_commit_title
    assert PRWithParams::OptionsValidator.validate!({ title: 'feat(frontend): Looking good!' }, validators: [:conventional_commits])
  end

  def test_that_it_validates_bad_conventional_commit_title
    error = assert_raises(PRWithParams::OptionsValidator::ValidatorError) do
      PRWithParams::OptionsValidator.validate!({ title: 'Looking good!' }, validators: [:conventional_commits])
    end

    assert_equal "Conventional commit specifications not met for commit message: 'Looking good!'", error.message
  end
end
