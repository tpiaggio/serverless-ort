import { CompareMyselfPage } from './app.po';

describe('compare-myself App', () => {
  let page: CompareMyselfPage;

  beforeEach(() => {
    page = new CompareMyselfPage();
  });

  it('should display message saying app works', () => {
    page.navigateTo();
    expect(page.getParagraphText()).toEqual('app works!');
  });
});
