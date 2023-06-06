require_relative "../test_helper"

class PRWithParams::OptionsValidatorTest < Minitest::Test
  def test_validator_class_mapping
    assert_equal PRWithParams::OptionsValidator::VALIDATOR_CLASS_MAP, { conventional_commits: 'PRWithParams::ConventionalCommitValidator' }
    assert_predicate PRWithParams::OptionsValidator::VALIDATOR_CLASS_MAP, :frozen?
  end

  def test_that_it_raises_argument_error_if_validator_undefined
    assert_raises(PRWithParams::OptionsValidator::ValidatorError, 'Invalid or undefined validator: bad_validator') do
      PRWithParams::OptionsValidator.validate!({}, validators: [:bad_validator])
    end
  end

  def test_that_it_validates_good_conventional_commit_title
    assert PRWithParams::OptionsValidator.validate!({ title: 'feat(frontend): Looking good!' }, validators: [:conventional_commits])
  end

  def test_that_it_validates_bad_conventional_commit_title
    assert_raises('Conventional commit specifications not met for commit message: Looking good!') do
      PRWithParams::OptionsValidator.validate!({ title: 'Looking good!' }, validators: [:conventional_commits])
    end
  end
end
