require 'spec_helper'

describe ApplicationHelper do

    describe "full_title" do
        it "应该包括页面标题" do
            expect(full_title("foo")).to match(/foo/)
        end

        it "应该包括基本标题" do
            expect(full_title("foo")).to match(/^G微博/)
        end

        it "不应该包含主页的栏" do
            expect(full_title("")).not_to match(/\|/)
        end
    end
end