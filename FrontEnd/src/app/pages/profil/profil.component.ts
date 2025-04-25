import { Component } from '@angular/core';
import { RouterLink, RouterLinkActive } from '@angular/router';
import { CommonModule } from '@angular/common';
import { UserService } from '../../services/user.service';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-home',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './profil.component.html',
  styleUrl: './profil.component.css'
})
export class ProfilComponent {
  user: any;
  isLoading: boolean = true;
  editMode: boolean = false;
  changePasswordMode: boolean = false;
  successMessage: string = '';
  errorMessage: string = '';

  // Champs du formulaire pour changer le mot de passe
  updatedUser: any = {};
  passwordData = {
    current_password: '',
    new_password: '',
    new_password_confirmation: ''
  };

  constructor(private userService: UserService) {}

  ngOnInit(): void {
    const token = localStorage.getItem('token') as string;
    this.userService.getUserByToken(token).subscribe({
      next: (response) => {
        this.user = response;
        this.isLoading = false;
        // console.log('Utilisateur récupéré:', this.user);
      },
      error: (error) => {
        console.error("Erreur lors de la récupération de l'utilisateur:", error);
        this.isLoading = false;
      }
    });
  }

  toggleEditMode() {
    this.editMode = !this.editMode;
    this.updatedUser = { ...this.user };
  }

  togglePasswordMode() {
    this.changePasswordMode = !this.changePasswordMode;
    this.passwordData = { current_password: '', new_password: '', new_password_confirmation: '' };
  }

  submitUserEdit() {
    console.log('Utilisateur mis à jour:', this.updatedUser);
  }

  submitPasswordChange() {
    this.successMessage = '';
    this.errorMessage = '';
  
    this.userService.changePassword(this.user.email, this.passwordData).subscribe({
      next: (response) => {
        // console.log('Mot de passe changé avec succès:', response);
        this.successMessage = 'Mot de passe changé avec succès.';
        this.changePasswordMode = false;
      },
      error: (error) => {
        // console.error('Erreur lors du changement de mot de passe:', error);
        this.errorMessage = error.error?.message || 'Une erreur est survenue.';
      }
    });
  }
}
