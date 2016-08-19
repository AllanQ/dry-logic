require 'dry/logic/rule/predicate'

RSpec.describe Operations::Disjunction do
  include_context 'predicates'

  subject(:rule) { Operations::Disjunction.new(left, right) }

  let(:left) { Rule::Predicate.new(none?) }
  let(:right) { Rule::Predicate.new(gt?).curry(18) }

  let(:other) do
    Rule::Predicate.new(int?) & Rule::Predicate.new(lt?).curry(14)
  end

  describe '#call' do
    it 'calls left and right' do
      expect(rule.(nil)).to be_success
      expect(rule.(19)).to be_success
      expect(rule.(18)).to be_failure
    end
  end

  describe '#and' do
    it 'creates conjunction with the other' do
      expect(rule.and(other).(nil)).to be_failure
      expect(rule.and(other).(19)).to be_failure
      expect(rule.and(other).(13)).to be_failure
      expect(rule.and(other).(14)).to be_failure
    end
  end

  describe '#or' do
    it 'creates disjunction with the other' do
      expect(rule.or(other).(nil)).to be_success
      expect(rule.or(other).(19)).to be_success
      expect(rule.or(other).(13)).to be_success
      expect(rule.or(other).(14)).to be_failure
    end
  end
end