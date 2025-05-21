import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ModerationViewComponent } from './moderation-view.component';

describe('ModerationViewComponent', () => {
  let component: ModerationViewComponent;
  let fixture: ComponentFixture<ModerationViewComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [ModerationViewComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(ModerationViewComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
