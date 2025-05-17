import { Component } from '@angular/core';
import { FormBuilder, FormGroup, Validators, ReactiveFormsModule, AbstractControl, ValidationErrors } from '@angular/forms';
import { RouterLink } from '@angular/router';
import { CommonModule } from '@angular/common';
import { GroupService } from '../../../services/group.service';
import { UserService } from '../../../services/user.service';

@Component({
  selector: 'app-create',
  imports: [ReactiveFormsModule, CommonModule],
  templateUrl: './create.component.html',
  styleUrl: './create.component.css'
})
export class CreateGroupComponent {
  userToken: string | null = localStorage.getItem('token');
  createGroupForm: FormGroup;
  group_owner: number = 0;
  showErrorMessage: boolean = false;

  constructor(
    private formBuilder: FormBuilder,
    private groupService: GroupService, 
    private userService: UserService
  ) {
    this.createGroupForm = this.formBuilder.group({
      name: [null, Validators.required],
      description: [null, Validators.required],
      logo: [null, [Validators.pattern(/\.(png|jpe?g|svg)$/)]],
    });
  }

  ngOnInit(): void {
    const currentUser = localStorage.getItem('currentUser') ? JSON.parse(localStorage.getItem('currentUser')!) : null;
    if (currentUser) {
      this.group_owner = currentUser.id;
    } else {
      this.showErrorMessage = true
    }
  }

  onSubmit(): void {
    if (this.createGroupForm.valid) {
      const formValues = this.createGroupForm.value;

      const createGroupData = {
        name: formValues.name,
        description: formValues.description,
        logo: formValues.logo || 'default_logo.png',
        group_owner: this.group_owner,
      };
            
      this.groupService.createGroup(createGroupData).subscribe({
        next: (response) => {
          console.log('Création du groupe réussie', response);
        },
        error: (error) => {
          console.error('Erreur lors de la création du groupe :', error);
        },
      });
    }
  }
}
