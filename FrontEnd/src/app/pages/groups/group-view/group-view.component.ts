import { Component } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-group-view',
  imports: [CommonModule],
  templateUrl: './group-view.component.html',
  styleUrl: './group-view.component.css'
})
export class GroupViewComponent {
  groupId!: number;

  posts = [
    {
      author: 'Anaïs',
      content: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque in ante quis magna faucibus tincidunt.',
      timestamp: '2 heures',
      likes: 5,
      comments: 2
    },
    {
      author: 'Émile',
      content: 'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.',
      timestamp: '4 heures',
      likes: 3,
      comments: 1
    }
  ];

  groups = [
    {
      name: 'Groupe Alpha',
      image: 'https://via.placeholder.com/48',
      lastActivity: 'Il y a 1h'
    },
    {
      name: 'Groupe Beta',
      image: 'https://via.placeholder.com/48',
      lastActivity: 'Il y a 3h'
    }
  ];

  constructor() {}

  // ngOnInit(): void {
  //   this.groupId = Number(this.route.snapshot.paramMap.get('id'));
  //   // Ici tu pourras faire un appel API avec this.groupId si besoin.
  // }
}