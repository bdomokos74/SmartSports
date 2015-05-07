class SensorMeasurement < ActiveRecord::Base
  belongs_to :user

  def has_cadence?
    return !self.cr_data.nil? && self.cr_data!=""
  end

  def has_heart?
    return !self.hr_data.nil? && self.hr_data!=""
  end

  def has_stride?
    return false
  end
end