#-- copyright
# OpenProject is a project management system.
# Copyright (C) 2012-2015 the OpenProject Foundation (OPF)
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 3.
#
# OpenProject is a fork of ChiliProject, which is a fork of Redmine. The copyright follows:
# Copyright (C) 2006-2013 Jean-Philippe Lang
# Copyright (C) 2010-2013 the ChiliProject Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
# See doc/COPYRIGHT.rdoc for more details.
#++

require 'spec_helper'
require_relative 'shared'

describe Queries::WorkPackages::Filter::VersionFilter, type: :model do
  let(:version) { FactoryGirl.build_stubbed(:version) }

  it_behaves_like 'work package query filter' do
    let(:order) { 7 }
    let(:type) { :list_optional }
    let(:class_key) { :fixed_version_id }
    let(:name) { WorkPackage.human_attribute_name('fixed_version_id') }

    describe '#available?' do
      context 'within a project' do
        it 'is true if any version exists' do
          allow(project)
            .to receive_message_chain(:shared_versions, :exists?)
            .and_return true

          expect(instance).to be_available
        end

        it 'is false if no version exists' do
          allow(project)
            .to receive_message_chain(:shared_versions, :exists?)
            .and_return false

          expect(instance).to_not be_available
        end
      end

      context 'outside of a project' do
        let(:project) { nil }

        it 'is true if any version exists' do
          allow(Version)
            .to receive_message_chain(:visible, :systemwide, :exists?)
            .and_return true

          expect(instance).to be_available
        end

        it 'is false if no version exists' do
          allow(Version)
            .to receive_message_chain(:visible, :systemwide, :exists?)
            .and_return false

          expect(instance).to_not be_available
        end
      end
    end

    describe '#values' do
      context 'within a project' do
        before do
          allow(Version)
            .to receive_message_chain(:visible, :systemwide)
            .and_return [version]

          expect(instance.values)
            .to match_array [[version.name, version.id.to_s]]
        end
      end

      context 'outside of a project' do
        before do
          allow(Version)
            .to receive_message_chain(:visible, :systemwide)
            .and_return [version]

          expect(instance.values)
            .to match_array [[version.name, version.id.to_s]]
        end
      end
    end
  end
end