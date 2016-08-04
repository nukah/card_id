require 'spec_helper'

describe Card do
  let(:cc) { described_class.new(value) }

  describe 'valid?' do
    context 'invalid input' do
      let(:value) { 'qwerty' }

      it { expect(cc).not_to be_valid }
    end

    context 'correct input' do
      let(:value) { '15012033881828312' }

      it { expect(cc).to be_valid }

      context 'with spaces' do
        let(:value) { '151  330 3000 11231' }

        it { expect(cc).to be_valid }
      end

      context 'with dashes' do
        let(:value) { '1115-1244-5124-2444' }

        it { expect(cc).to be_valid }
      end
    end
  end

  describe '#correct?' do
    context 'with invalid CRC from test case' do
      let(:value) { '4417 1234 5678 9112' }

      it { expect(cc).not_to be_correct }
    end

    context 'wtih valid CRC from test case' do
      let(:value) { '4408 0412 3456 7893' }

      it { expect(cc).to be_correct }
    end

    context 'with valid CRC considering CC to have odd size' do
      let(:value) { '6011734899726424' }

      it { expect(cc).to be_correct }
    end
  end

  describe '#system' do
    subject { cc.system }

    context 'Mastercard' do
      let(:value) { '5551148570410158' }

      it { expect(subject).to eq 'Mastercard' }
    end

    context 'Discover' do
      let(:value) { '6011715502885681' }

      it { expect(subject).to eq 'Discover' }
    end

    context 'VISA' do
      context 'with 13 numbers' do
        let(:value) { '4627547243101' }

        it { expect(subject).to eq 'VISA' }
      end

      context 'with 16 numbers' do
        let(:value) { '4322484733444573' }

        it { expect(subject).to eq 'VISA' }
      end
    end

    context 'AMEX' do
      let(:value) { '373359141968692' }

      it { expect(subject).to eq 'AMEX' }
    end

    context 'Unknown' do
      let(:value) { '5893835772928485' }

      it { expect(subject).to eq 'Unknown' }
    end
  end
end
